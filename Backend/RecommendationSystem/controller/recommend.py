# controller/recommend.py
from flask import request, jsonify
import joblib
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from underthesea import word_tokenize
import os

def vietnamese_tokenizer(text):
    if pd.isna(text):
        return []
    return word_tokenize(str(text), format="text").split()

# Đường dẫn đến thư mục data_train
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BASE_DIR, '..', 'data_train')

# Tải các model và dữ liệu đã lưu
tfidf, scaler, kmeans, features, clusters, data = None, None, None, None, None, None
try:
    tfidf = joblib.load(os.path.join(DATA_DIR, 'tfidf_model.pkl'))
    scaler = joblib.load(os.path.join(DATA_DIR, 'scaler_model.pkl'))
    kmeans = joblib.load(os.path.join(DATA_DIR, 'kmeans_model.pkl'))
    features = joblib.load(os.path.join(DATA_DIR, 'features.pkl'))
    clusters = joblib.load(os.path.join(DATA_DIR, 'clusters.pkl'))
    data = pd.read_pickle(os.path.join(DATA_DIR, 'data_with_clusters.pkl'))
    print("Đã tải thành công các model và dữ liệu.")
except FileNotFoundError:
    print("Lỗi: Không tìm thấy các file model hoặc dữ liệu trong thư mục data_train. Hãy kiểm tra lại.")
except Exception as e:
    print(f"Lỗi khi tải model hoặc dữ liệu: {e}")

def get_all_sorted_potential_recommendations(product_ids, df=data, features=features, clusters=clusters, kmeans=kmeans):
    if df is None or features is None or clusters is None or kmeans is None:
        print("Lỗi: Các model hoặc dữ liệu chưa được tải.")
        return []

    potential_recommendations = {}
    if '_id' not in df.columns:
        print("Lỗi: Cột '_id' không tồn tại trong dataframe.")
        return []

    id_to_index = {id_: index for index, id_ in enumerate(df['_id'])}

    for product_id in product_ids:
        if product_id not in id_to_index:
            print(f"Product ID {product_id} không tìm thấy trong dữ liệu, bỏ qua!")
            continue

        idx = id_to_index[product_id]
        product_cluster = clusters[idx]
        cluster_indices = np.where(clusters == product_cluster)[0]
        product_features = features[idx].reshape(1, -1)
        cluster_features = features[cluster_indices]

        if len(cluster_features) <= 1:
            continue

        similarities = cosine_similarity(product_features, cluster_features)[0]

        for i, cluster_idx in enumerate(cluster_indices):
            if cluster_idx == idx:
                continue

            rec_product_id = df.iloc[cluster_idx]['_id']
            similarity_score = similarities[i]
            rec_product_info = df.iloc[cluster_idx][['_id']].to_dict()

            if rec_product_id not in potential_recommendations or similarity_score > potential_recommendations[rec_product_id][0]:
                potential_recommendations[rec_product_id] = (similarity_score, rec_product_info)

    sorted_recommendations_list = list(potential_recommendations.values())
    sorted_recommendations_list.sort(key=lambda item: item[0], reverse=True)
    final_recommendations_info = [item[1] for item in sorted_recommendations_list]

    return final_recommendations_info

def get_recommendations():
    if request.method == 'POST':
        data_json = request.get_json()
        if not data_json or 'productIds' not in data_json:
            return jsonify({"error": "Yêu cầu phải chứa trường 'productIds' dạng mảng."}), 400

        input_product_ids = data_json.get('productIds', [])
        if not isinstance(input_product_ids, list):
            return jsonify({"error": "'productIds' phải là một mảng."}), 400

        recommendations = get_all_sorted_potential_recommendations(input_product_ids)
        return jsonify(recommendations), 200

    return jsonify({"error": "Chỉ chấp nhận phương thức POST"}), 405
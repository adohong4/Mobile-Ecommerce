# recommend.py
from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
# Import underthesea để hàm tokenizer hoạt động
from underthesea import word_tokenize

# Định nghĩa lại hàm tokenizer giống như trong notebook
# Hàm này cần phải tồn tại trong môi trường khi tải mô hình TF-IDF
def vietnamese_tokenizer(text):
    """
    Tokenizer tiếng Việt sử dụng underthesea.
    Cần thiết để tải mô hình TF-IDF đã được huấn luyện.
    """
    # Đảm bảo text là string và không phải NaN
    if pd.isna(text):
        return []
    return word_tokenize(str(text), format="text").split()


# Tải các model và dữ liệu đã lưu
tfidf, scaler, kmeans, features, clusters, data = None, None, None, None, None, None
try:
    # Tải tfidf_model.pkl sau khi đã định nghĩa vietnamese_tokenizer
    tfidf = joblib.load('tfidf_model.pkl')
    scaler = joblib.load('scaler_model.pkl')
    kmeans = joblib.load('kmeans_model.pkl')
    features = joblib.load('features.pkl')
    clusters = joblib.load('clusters.pkl')
    data = pd.read_pickle('data_with_clusters.pkl')
    print("Đã tải thành công các model và dữ liệu.")
except FileNotFoundError:
    print("Lỗi: Không tìm thấy các file model hoặc dữ liệu. Hãy chạy lại notebook để tạo chúng.")
    # Đặt các biến thành None để chỉ báo lỗi
    tfidf, scaler, kmeans, features, clusters, data = None, None, None, None, None, None
except Exception as e:
    print(f"Lỗi khi tải model hoặc dữ liệu: {e}")
    tfidf, scaler, kmeans, features, clusters, data = None, None, None, None, None, None


app = Flask(__name__)
CORS(app) # Cho phép CORS từ mọi nguồn (có thể cấu hình cụ thể hơn nếu cần)

def get_all_sorted_potential_recommendations(product_ids, df, features, clusters, kmeans):
    """
    Hàm gợi ý sản phẩm dựa trên ID đầu vào.
    Kết hợp tất cả gợi ý từ các sản phẩm đầu vào, sắp xếp theo độ tương đồng cao nhất đạt được,
    và trả về TẤT CẢ sản phẩm gợi ý duy nhất đã sắp xếp.
    """
    if df is None or features is None or clusters is None or kmeans is None:
        print("Lỗi: Các model hoặc dữ liệu chưa được tải.")
        return [] # Trả về danh sách rỗng nếu hệ thống chưa sẵn sàng

    # Sử dụng dictionary để lưu trữ sản phẩm gợi ý tiềm năng và độ tương đồng cao nhất của nó
    # Key: product_id, Value: (max_similarity_score, product_info_dict)
    potential_recommendations = {}

    # Tạo một mapping từ _id sang index để truy cập nhanh hơn
    if '_id' not in df.columns:
         print("Lỗi: Cột '_id' không tồn tại trong dataframe.")
         return []

    id_to_index = {id_: index for index, id_ in enumerate(df['_id'])}

    for product_id in product_ids:
        # Bỏ qua các ID không hợp lệ hoặc không tìm thấy
        if product_id not in id_to_index:
            print(f"Product ID {product_id} không tìm thấy trong dữ liệu, bỏ qua!")
            continue

        idx = id_to_index[product_id]
        product_cluster = clusters[idx]

        # Lấy các index của sản phẩm trong cùng cụm
        cluster_indices = np.where(clusters == product_cluster)[0]

        # Trích xuất đặc trưng của sản phẩm đầu vào và các sản phẩm trong cùng cụm
        product_features = features[idx].reshape(1, -1)
        cluster_features = features[cluster_indices]

        # Tính độ tương đồng cosine giữa sản phẩm đầu vào và TẤT CẢ sản phẩm trong cụm
        # Xử lý trường hợp cụm chỉ có 1 sản phẩm (chính nó)
        if len(cluster_features) <= 1:
             # Không có sản phẩm khác để gợi ý trong cụm này
             continue

        similarities = cosine_similarity(product_features, cluster_features)[0]

        # Duyệt qua các sản phẩm trong cụm
        for i, cluster_idx in enumerate(cluster_indices):
            # Bỏ qua sản phẩm đầu vào
            if cluster_idx == idx:
                continue

            rec_product_id = df.iloc[cluster_idx]['_id']
            similarity_score = similarities[i] # Lấy điểm tương đồng tương ứng

            # Lấy thông tin sản phẩm gợi ý
            rec_product_info = df.iloc[cluster_idx][['_id']].to_dict()

            # Cập nhật hoặc thêm sản phẩm vào dictionary nếu điểm tương đồng cao hơn
            if rec_product_id not in potential_recommendations or similarity_score > potential_recommendations[rec_product_id][0]:
                potential_recommendations[rec_product_id] = (similarity_score, rec_product_info)

    # Chuyển dictionary thành danh sách các tuple (score, product_info)
    sorted_recommendations_list = list(potential_recommendations.values())

    # Sắp xếp danh sách theo điểm tương đồng giảm dần
    sorted_recommendations_list.sort(key=lambda item: item[0], reverse=True)

    # Lấy thông tin sản phẩm từ TOÀN BỘ danh sách đã sắp xếp
    final_recommendations_info = [item[1] for item in sorted_recommendations_list] # Bỏ [:top_n]

    return final_recommendations_info

@app.route('/v1/api/recommend/viewed', methods=['POST'])
def get_recommendations():
    """
    Endpoint API nhận danh sách productIds và trả về danh sách TẤT CẢ gợi ý tiềm năng
    đã sắp xếp theo độ tương đồng cao nhất.
    """
    if request.method == 'POST':
        data_json = request.get_json()
        if not data_json or 'productIds' not in data_json:
            return jsonify({"error": "Yêu cầu phải chứa trường 'productIds' dạng mảng."}), 400

        input_product_ids = data_json.get('productIds', [])

        if not isinstance(input_product_ids, list):
             return jsonify({"error": "'productIds' phải là một mảng."}), 400

        # Gọi hàm gợi ý sản phẩm mới trả về danh sách TẤT CẢ gợi ý tiềm năng đã sắp xếp
        recommendations = get_all_sorted_potential_recommendations(input_product_ids, data, features, clusters, kmeans) # Bỏ tham số top_n

        # Trả về danh sách gợi ý trực tiếp
        return jsonify(recommendations), 200

    # Mặc định trả về lỗi nếu không phải phương thức POST
    return jsonify({"error": "Chỉ chấp nhận phương thức POST"}), 405

if __name__ == '__main__':
    # Chạy ứng dụng Flask
    app.run(debug=True, host='0.0.0.0', port=5000)

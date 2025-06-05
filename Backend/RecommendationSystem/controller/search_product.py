# controller/search_product.py
from flask import request, jsonify
import pandas as pd
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import os

# Đường dẫn đến thư mục data_train
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_DIR = os.path.join(BASE_DIR, '..', 'data_train')

# Load precomputed embeddings
df = pd.read_pickle(os.path.join(DATA_DIR, 'products_embeddings.pkl'))

# Load SentenceTransformer model
model = SentenceTransformer('all-MiniLM-L6-v2')

def recommend_products():
    try:
        data = request.get_json()
        query = data.get('query', '')
        top_k = data.get('top_k', 15)

        if not query:
            return jsonify({'error': 'Query is required'}), 400

        query_embedding = model.encode(query)
        df['similarity'] = df['embeddings'].apply(lambda x: cosine_similarity([query_embedding], [x]).flatten()[0])
        recommendations = df.sort_values(by='similarity', ascending=False).head(top_k)
        result = recommendations[['_id', 'similarity']].to_dict(orient='records')

        return jsonify({'recommendations': result}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

app = Flask(__name__)
CORS(app)  # Cho phép CORS để React frontend có thể gọi API

# Load precomputed embeddings
df = pd.read_pickle('products_embeddings.pkl')

# Load SentenceTransformer model
model = SentenceTransformer('all-MiniLM-L6-v2')

@app.route('/v1/api/recommend', methods=['POST'])
def recommend_products():
    try:
        # Get query from request
        data = request.get_json()
        query = data.get('query', '')
        top_k = data.get('top_k', 15)  # Default to 5 if not provided

        if not query:
            return jsonify({'error': 'Query is required'}), 400

        # Embed the query
        query_embedding = model.encode(query)

        # Compute cosine similarity with all products
        df['similarity'] = df['embeddings'].apply(lambda x: cosine_similarity([query_embedding], [x]).flatten()[0])

        # Sort products by similarity score
        recommendations = df.sort_values(by='similarity', ascending=False).head(top_k)
        
        # Prepare response
        result = recommendations[['_id','similarity']].to_dict(orient='records')
        
        return jsonify({'recommendations': result}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
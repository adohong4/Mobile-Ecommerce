# server.py
from flask import Flask
from flask_cors import CORS
import sys
import os
import pandas as pd
from underthesea import word_tokenize

# Thêm thư mục 'controller' vào sys.path để import các module
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'controller'))

# Định nghĩa vietnamese_tokenizer trong __main__
def vietnamese_tokenizer(text):
    if pd.isna(text):
        return []
    return word_tokenize(str(text), format="text").split()

# Import các hàm từ recommend.py và search_product.py
from recommend import get_recommendations
from search_product import recommend_products

# Tạo ứng dụng Flask chính
app = Flask(__name__)
CORS(app)  # Cho phép CORS cho toàn bộ ứng dụng

# Đăng ký các route
app.route('/v1/api/recommend/viewed', methods=['POST'])(get_recommendations)
app.route('/v1/api/recommend', methods=['POST'])(recommend_products)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
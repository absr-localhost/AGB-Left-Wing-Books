#!/usr/bin/env python3
"""Mencetak daftar id buku yang mungkin berbahasa Inggris (untuk alur terjemahan)."""
import json
import os

akar = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
with open(os.path.join(akar, 'tool', 'sumber_buku.json'), encoding='utf-8') as f:
    daftar = json.load(f)
ids = [x['id'] for x in daftar
       if x.get('bahasa') == 'en' or x.get('cadangan', {}).get('bahasa') == 'en']
print(json.dumps(ids))

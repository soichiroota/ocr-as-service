import os
import io
import csv

import responder
from PIL import Image
import pytesseract


env = os.environ
DEBUG = env['DEBUG'] in ['1', 'True', 'true']
LANG = env['LANG']

api = responder.API(debug=DEBUG)


def get_data_dicts(img, lang=None):
    if lang:
        data = pytesseract.image_to_data(img, lang=lang)
    else:
        data = pytesseract.image_to_data(img)
    tsv = csv.DictReader(data.splitlines(), delimiter='\t')
    return [dict(row) for row in tsv]


@api.route("/")
async def encode(req, resp):
    body = await req.content
    img = Image.open(io.BytesIO(body))
    data_dicts = get_data_dicts(img, lang=LANG)
    resp.media = dict(data=data_dicts)


if __name__ == "__main__":
    api.run()
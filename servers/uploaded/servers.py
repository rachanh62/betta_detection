from ultralytics import YOLO
from flask import request, Flask, jsonify
from waitress import serve
from PIL import Image

app = Flask(__name__)

@app.route("/")
def root():

    with open("index.html") as file:
        return file.read()


@app.route("/uploaded", methods=["POST"])
def detect():
    buf = request.files["image_file"]
    boxes = detect_objects_on_image(buf.stream)
    return jsonify(boxes)


def detect_objects_on_image(buf):
    model = YOLO("betta_model.pt")
    results = model.predict(Image.open(buf),max_det = 1)
    result = results[0]
    output = []
    for box in result.boxes:
        x1, y1, x2, y2 = [
            round(x) for x in box.xyxy[0].tolist()
        ]
        class_id = box.cls[0].item()
        prob = round(box.conf[0].item(), 4)
        output.append([
            x1, y1, x2, y2, result.names[class_id], prob*100
        ])
    return output


if __name__ == '__main__':
  app.debug = True
  app.run(host='0.0.0.0', port=5000)
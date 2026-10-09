import tensorflow as tf
from aifes import keras2aifes

MODEL = tf.keras.models.load_model('C:\Users\simwi\OneDrive\Desktop\EMBEDDED IA\Aifes\models\5dense-mnist-10class-finetuned.h5')

BASE_PATH = "." # Le dossier courant
test_name = "mon_mnist"

# 3. Lancer la conversion spécifique en Float 32 (F32)
keras2aifes.convert_to_fnn_f32(MODEL, BASE_PATH + "/f32/" + test_name)
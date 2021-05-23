#/usr/bin/env bash

export TASK_NAME=justification


# Download file unless it exists
upsert_file(){
    if (( $# != 2 )); then
        >&2 echo "Illegal number of parameters"
        echo "usage: ${0} <download-path> <URL>"
        exit 1
    fi
    path="$1"
    url="$2"
    [[ -f "$path" ]] || wget -O "$path" "$url"
}

upsert_file "./${TASK_NAME}/bert_config.json" "http://deepyeti.ucsd.edu/jianmo/recsys_justification/model/justification_classifier/bert_config.json"
upsert_file "./${TASK_NAME}/pytorch_model.bin" "http://deepyeti.ucsd.edu/jianmo/recsys_justification/model/justification_classifier/pytorch_model.bin"

pip install pytorch_pretrained_bert==0.4.0

python bert_predict_classification.py \
	--task_name "$TASK_NAME" \
	--do_eval \
	--do_lower_case \
	--data_dir "./$TASK_NAME" \
        --config_file "./$TASK_NAME/bert_config.json" \
        --model_file "./$TASK_NAME/pytorch_model.bin" \
	--bert_model bert-base-uncased \
	--max_seq_length 64 \
	--eval_batch_size 32 \
	--learning_rate 2e-5 \
	--output_dir "./tmp/$TASK_NAME"

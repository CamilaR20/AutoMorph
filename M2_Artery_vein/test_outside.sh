#This is SH file for LearningAIM

export PYTHONPATH=.:$PYTHONPATH

seed_number=42
dataset_name='ALL-AV'
test_checkpoint=1401

date
python test_outside.py --batch-size=8 \
                        --dataset=${dataset_name} \
                        --job_name=20210724_${dataset_name}_randomseed \
                        --checkstart=${test_checkpoint} \
                        --uniform=True


date


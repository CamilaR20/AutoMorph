#!/bin/bash

# parent_dir="/gpfs01/berens/data/data/NAKO/nako-decrypted/512_raw"
parent_dir="/gpfs01/berens/user/mroa/AutoMorph/test"
image_types=(
    "rt_leftcentral"
    "rt_leftnasal"
    "rt_rightcentral"
    "rt_rightnasal"
)
output_dir="/gpfs01/berens/user/mroa/automorph_results"
mkdir -p $output_dir

for image_type in "${image_types[@]}"; do
    for idx in {1..3}; do
        top_dir="${parent_dir}/${image_type}_${idx}"
        images_dir="${parent_dir}/images"
        echo "Analyzing images in $top_dir..."

        # Create the file structure automorph expects
        mv $top_dir $images_dir
        mkdir $top_dir
        mv $images_dir $top_dir
        export AUTOMORPH_DATA="${top_dir}"
        python generate_resolution.py 1

        # Run automorph
        export CUDA_VISIBLE_DEVICES="1"
        ./run.sh --no_segmentation --no_feature

        # Move automorph results to output_dir
        results_dir="${top_dir}/Results"
        output_results_dir="${output_dir}/${image_type}_${idx}/"
        echo "Moving results to ${output_results_dir}..."
        mkdir -p $output_results_dir
        mv $results_dir/* $output_results_dir

        # Restore original file structure
        rmdir $results_dir
        resolution_file="${top_dir}/resolution_information.csv"
        rm $resolution_file
        images_dir="${top_dir}/images"
        mv "${images_dir}"/* $top_dir
        rmdir "${images_dir}"

        break 2
    done
done

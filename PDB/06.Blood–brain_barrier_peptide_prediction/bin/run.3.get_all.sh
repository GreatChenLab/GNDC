ls split_output/ | xargs -I{} sh -c 'realpath split_output/{} | awk "{print \"sh run.sh\",\$1,\"{}.out\"}"' > run.4.all.sh

crrent_path=`pwd`
docker run -v $current_path/data:/tmp/data  -w="/tmp" kiwenlau/tophat-cufflinks bash -c "sleep 2 && cd data && pwd && ls"
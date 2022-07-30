FROM     alpine:latest as script
LABEL    stage=my_app_alpine
WORKDIR	 /opt/scripts
RUN	 echo -e '#!/bin/bash\nif [ -f "$1" ]; \n then \n echo "Removing $1 file..." && rm -f $1 \n else \n echo "$1 file does not exist." \n fi' > remove_if_exists.sh
RUN      echo -e '#!/bin/bash\nif [ ! -d "$1" ]; \n then \n echo "dist folder is not generated. Generating new dist folder..." && mkdir $1 && cd $1 && echo "<h1>Project is not builded</h1>" > index.html \n fi \n echo "Build process finished."' > check_dist.sh


FROM	 node:latest as my_node
LABEL    stage=my_app_node
RUN	 mkdir /opt/scripts
COPY     --from=script /opt/scripts/* /opt/scripts/
RUN      chmod +x /opt/scripts/*
COPY     my_app /opt/my_app
WORKDIR  /opt/my_app
RUN	 ["/bin/bash", "-c", "/opt/scripts/remove_if_exists.sh package-lock.json"]
RUN	 npm install -g @angular/cli
RUN	 npm install
RUN	 ng build --configuration=production
RUN	 /opt/scripts/check_dist.sh dist

FROM	nginx:latest
RUN	rm -rf /usr/share/nginx/html/*
COPY	--from=my_node /opt/my_app/dist/*  /usr/share/nginx/html/

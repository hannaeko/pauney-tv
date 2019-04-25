# PauneyTV

Features :
 * vod recording on the server
 * multi-resolution support (currently : Source, 720p, 360p)
 * webchat via IRC

The docker file is based on the work of https://github.com/LoicMahieu/alpine-nginx/ .

## Usage

```
docker build -t tv .
docker run -d -p 8000:80 -p 1935:1935 tv
```

Set the streaming server on OBS to `custom`, the url to `rtmp://localhost:1935/live` and the streaming key to `test`. Then navigate with your browser to `localhost:8000`, done!
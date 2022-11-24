### local development
Navigate to `/lite` and run `docker compose up` <br />
To view the resulting diagram, visit http://localhost:8080 in a browser window

# Push documentation to online server structurizr.bbnavi.de

```
structurizr-cli push  -w lite/data/bbnavi.dsl -id 3 -key KEY -secret SECRET -url https://structurizr.bbnavi.de/api
```

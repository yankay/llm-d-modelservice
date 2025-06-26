# Examples

This folder contains example values file and their rendered templates.

```
helm template [RELEASE-NAME] . -f [VALUES-FILEPATH]
```

1. `vllm-sim` in Kind 

    Make sure there is a gateway (Kgteway or Istio) deployed in the cluster named `llm-d-inference-gateway` or change values file accordingly. Follow [these instructions](https://gateway-api-inference-extension.sigs.k8s.io/guides/#__tabbed_3_2) on how to set up a gateway.
    
    Dry run:
    
    ```
    helm template llmd-sim . -f examples/values-vllm-sim.yaml > examples/output-vllm-sim.yaml
    ```
    
    Install in a Kind cluster:
    
    ```
    helm install llmd-sim . -f examples/values-vllm-sim.yaml
    ```
    
    Port forward the inference gateway 

    ```
    k port-forward svc/llm-d-inference-gateway-istio 8000:80
    ```
    
    Send a request.
    
    ```
    curl http://localhost:8000/v1/completions -vvv \
        -H "Content-Type: application/json" \
        -H "x-model-name: random" \
        -d '{
        "model": "random",
        "prompt": "Hello, "
    }'
    ```
    
    You should see a response like the following: 
    
    ```
    {"id":"chatcmpl-05cfe79c-234d-4898-b781-3fa59ba7be49","created":1750969231,"model":"random","choices":[{"index":0,"finish_reason":"stop","text":"Alas, poor Yorick! I knew him, Horatio: A fellow of infinite jest"}]}
    ```


2. `facebook/opt-125m`: downloads from Hugging Face 

    Dry-run:
    
    ```
    helm template facebook . -f examples/values-facebook.yaml > examples/output-facebook.yaml
    ```
    
    or install in a cluster 
    
    
    ```
    helm template facebook . -f examples/values-facebook.yaml
    ```
    
    
    Port forward the inference gateway 

    ```
    k port-forward svc/llm-d-inference-gateway-istio 8000:80
    ```
        
    Send a request:

    ```
    curl http://localhost:8000/v1/completions -vvv \
        -H "Content-Type: application/json" \
        -H "x-model-name: facebook/opt-125m" \
        -d '{
        "model": "facebook/opt-125m",
        "prompt": "Hello, "
    }'
    ```
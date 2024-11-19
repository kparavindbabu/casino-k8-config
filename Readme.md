# ArgoCD login:

kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

http://127.0.0.1:8080
admin
OrT3BkayfN7XGdoM
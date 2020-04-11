# gcsfuse


```
      containers:
        - name: gcsfuse
          image: synchrone/gcsfuse
          env:
          - name: BUCKET
            value: my-bucket-name
          securityContext:
            privileged: true
            capabilities:
              add:
                - SYS_ADMIN
          volumeMounts:
            - name: gcsfuse
              mountPath: /mnt
              mountPropagation: Bidirectional
      ...
      volumes:
        - name: gcsfuse
          emptyDir:
            sizeLimit: 10G
```

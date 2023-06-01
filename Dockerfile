FROM hashicorp/terraform:1.4.6

RUN apk add --no-cache bash

ENTRYPOINT ["/bin/bash"]

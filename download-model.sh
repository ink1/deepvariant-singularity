#!/bin/bash
# download models
#gsutil -m ls gs://deepvariant/
gsutil -m cp -r gs://deepvariant/models/DeepVariant/0.6.0 .

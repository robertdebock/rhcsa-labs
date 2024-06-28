# RHCSA labs

This repository creates a lab environment to excersie RHCSA exams.

## Overview

```text
+--- workstation ---+
|                   |---------+
+-------------------+         |
         |                    |
        ssh                  ssh
         |                    |
         V                    V
+--- server-1 ---+   +--- server-2 ---+
|                |   |                |
+----------------+   +----------------+
```

## Setup

```bash
cd terraform
terraform init
terraform apply
ssh workstation.adfinis.dev
sudo rhc connect --username robert.debock@adfinis.com --password 'YoUrPaSsWoRdHeRe'
sudo dnf update rh-amazon-rhui-client
ssh server-1.adfinis.dev
sudo rhc connect --username robert.debock@adfinis.com --password 'YoUrPaSsWoRdHeRe'
sudo dnf update rh-amazon-rhui-client
ssh server-2.adfinis.dev
sudo rhc connect --username robert.debock@adfinis.com --password 'YoUrPaSsWoRdHeRe'
sudo dnf update rh-amazon-rhui-client
exit
exit
```

## Questions

Please see [QUESTIONS](QUESTIONS.md) for the questions and some answers.

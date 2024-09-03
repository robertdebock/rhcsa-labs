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
+--- server-0 ---+   +--- server-1 ---+
|                |   |                |
+----------------+   +----------------+
```

## Setup

```bash
cd terraform
terraform init
terraform apply
ssh workstation.adfinis.dev
exit
ssh server-0.adfinis.dev
```

## Questions

Please see [EXAM](EXAM.md) and [EXPLANATION](EXPLANATION.md) for the questions and some answers.

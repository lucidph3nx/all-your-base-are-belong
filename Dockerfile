FROM cimg/base:current-20.04

ARG TZ="Etc/UTC"


# Install yq
RUN curl --silent --location --output /usr/bin/yq "https://github.com/mikefarah/yq/releases/download/v4.28.1/yq_linux_amd64" \
    && chmod +x /usr/bin/yq \
    && yq --version

#install Terraform & Terragrunt using tfenv & tgenv
ENV PATH="/usr/local/lib/.tfenv/bin:/usr/local/lib/.tgenv/bin:${PATH}"

RUN set -x && git clone https://github.com/tfutils/tfenv.git /usr/local/lib/.tfenv \
&& tfenv install 0.12.16 \
&& tfenv install 0.12.26 \
&& tfenv install 0.12.31 \
&& tfenv use 0.12.16 \
&& tfenv list \
&& terraform -v

RUN set -x && git clone https://github.com/cunymatthieu/tgenv.git /usr/local/lib/.tgenv \
&& mkdir -p /usr/local/lib/.tgenv/versions/0.21.1 \
&& curl --location --output /usr/local/lib/.tgenv/versions/0.21.1/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.21.1/terragrunt_linux_amd64 \
&& chmod +x /usr/local/lib/.tgenv/versions/0.21.1/terragrunt \
&& mkdir -p /usr/local/lib/.tgenv/versions/0.24.4 \
&& curl --location --output /usr/local/lib/.tgenv/versions/0.24.4/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.24.4/terragrunt_linux_amd64 \
&& chmod +x /usr/local/lib/.tgenv/versions/0.24.4/terragrunt \
&& tgenv use 0.21.1 \
&& tgenv list \
&& terragrunt -v

# Install aws-cli v2
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip -q awscliv2.zip \
    && aws/install \
    && aws --version \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples

WORKDIR /apps

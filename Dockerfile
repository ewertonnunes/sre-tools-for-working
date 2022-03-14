
FROM ubuntu:20.04
WORKDIR /cloud
ARG UID=1000
ARG USER_NAME=eflorencio
ARG GID=1000
ARG GROUP_NAME=eflorencio

RUN if ! id ${USER_NAME}; then groupadd -r -g ${GID} ${GROUP_NAME} && useradd -r -g ${GROUP_NAME} -u ${UID} ${USER_NAME}; fi
RUN mkdir -p /home/${USER_NAME}

ENV HOME /home/${USER_NAME}
ENV ANSIBLE_VERSION 2.9.8
ENV AWS_CLI_VERSION 1.18.57
ENV GCLOUD_VERSION 334.0.0-0
ENV HELM_VERSION v3.8.1
ENV KUBECTL_VERSION v1.18.5
ENV KUBETOOLS_VERSION v0.9.4
ENV TERRAFORM_VERSION 1.1.7
ENV TERRAFORM_SHA256SUM ddf9b409599b8c3b44d4e7c080da9a106befc1ff9e53b57364622720114e325c
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	ca-certificates \
	curl \
	git \
	net-tools \
	gnupg2 \
	groff \
    iputils-ping \
	jq \
	netcat \
	openssh-client \
	python3 \
	python3-distutils \
	unzip \
	vim \
	wget \
	shellcheck \
	yamllint \
	&& rm -rf /var/lib/apt/lists/*
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
	&& python3 get-pip.py \
	&& rm get-pip.py
	
RUN pip3 install --upgrade \
	ansible==${ANSIBLE_VERSION} \
	awscli==${AWS_CLI_VERSION}

RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator \
	&& chmod +x ./aws-iam-authenticator \
	&& mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
	&& curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
	&& apt-get update -y \
	&& apt-get install google-cloud-sdk=${GCLOUD_VERSION} -y \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
	&& tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz \
	&& chmod +x linux-amd64/helm \
	&& mv linux-amd64/helm /usr/local/bin/helm

RUN curl -LO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx \
	&& chmod +x kubectx \
	&& mv kubectx /usr/local/bin/

RUN curl -LO https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens \
	&& chmod +x kubens \
	&& mv kubens /usr/local/bin/

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl \
	&& mv ./kubectl /usr/local/bin/kubectl

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
	&& echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS \
	&& sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS \
	&& unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin \
	&& rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ARG VELERO_VERSION=v1.6.3

RUN curl --location https://github.com/vmware-tanzu/velero/releases/download/$VELERO_VERSION/velero-$VELERO_VERSION-linux-amd64.tar.gz \
	| tar --file=- --extract --gzip --directory=/usr/local/bin --strip-components=1 velero-$VELERO_VERSION-linux-amd64/velero

USER ${USER_NAME}

CMD tail -f /dev/null
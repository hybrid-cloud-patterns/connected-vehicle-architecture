.PHONY: default
default: help

.PHONY: help
# No need to add a comment here as help is described in common/
help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) common/Makefile | sort | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

%:
	make -f common/Makefile $*

install: operator-deploy post-install ## installs the pattern, inits the vault and loads the secrets
	echo "Installed"

post-install: ## Post-install tasks - vault init and load-secrets
	@echo "Done"

test:
	make -f common/Makefile PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test

.PHONY: kubeconform
KUBECONFORM_SKIP=-skip 'CustomResourceDefinition,Integration,BobbycarZone,Infinispan,Kafka,KafkaBridge,KafkaTopic,ActiveMQArtemis,EventListener,TriggerBinding,TriggerTemplate,Pipeline,Trigger,Task,ApiServerSource,Service,KafkaSource,Broker'
kubeconform:
	make -f common/Makefile KUBECONFORM_SKIP="$(KUBECONFORM_SKIP)" kubeconform

FROM php:7.4-alpine

# tools
ENV PHPCS_VERSION=3.6.2

# rulesets
# https://github.com/WordPress/WordPress-Coding-Standards
# https://github.com/automattic/vip-coding-standards
# https://github.com/sirbrillig/phpcs-variable-analysis/releases
# https://github.com/phpcompatibility/phpcompatibility/releases
# https://github.com/phpcompatibility/phpcompatibilitywp/releases
ENV RULESET_WP_CODING_STANDARDS_VERSION=2.3.0 \
  RULESET_VIP_CODING_STANDARDS_VERSION=2.3.2 \
  RULESET_PHPCS_VARIABLE_ANALYSIS_VERSION=2.11.0 \
  RULESET_PHP_COMPATIBILITY_VERSION=9.3.5 \
  RULESET_PHP_COMPATIBILITY_WP_VERSION=2.1.1\
  RULESET_RC_SNAKESTANDARD_VERSION=0.0.2

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git

# tools
RUN wget -P /usr/local/bin -q https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${PHPCS_VERSION}/phpcs.phar
RUN wget -P /usr/local/bin -q https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${PHPCS_VERSION}/phpcbf.phar
RUN chmod +x /usr/local/bin/phpcs.phar
RUN chmod +x /usr/local/bin/phpcbf.phar

# rulesets
RUN mkdir -p /tmp/rulesets
RUN wget -O - -q https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards/archive/${RULESET_WP_CODING_STANDARDS_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 1 --wildcards-match-slash --wildcards '*/WordPress*'
RUN wget -O - -q https://github.com/Automattic/VIP-Coding-Standards/archive/${RULESET_VIP_CODING_STANDARDS_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 1 --wildcards-match-slash --wildcards '*/WordPress*'
RUN wget -O - -q https://github.com/sirbrillig/phpcs-variable-analysis/archive/v${RULESET_PHPCS_VARIABLE_ANALYSIS_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 1 --wildcards-match-slash --wildcards '*/VariableAnalysis*'
RUN wget -O - -q https://github.com/PHPCompatibility/PHPCompatibility/archive/${RULESET_PHP_COMPATIBILITY_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 1 --wildcards-match-slash --wildcards '*/PHPCompatibility*'
RUN wget -O - -q https://github.com/PHPCompatibility/PHPCompatibilityWP/archive/${RULESET_PHP_COMPATIBILITY_WP_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 1 --wildcards-match-slash --wildcards '*/PHPCompatibility*'
RUN wget -O - -q https://github.com/chssmith/SnakeStandard/archive/refs/tags/v${RULESET_RC_SNAKESTANDARD_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 1 --wildcards-match-slash --wildcards '*/SnakeStandard*'

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

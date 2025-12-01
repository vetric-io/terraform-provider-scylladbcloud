# Changelog

## 1.0.0 (2025-12-01)


### Features

* add allowCQL field to model.VPCPeering ([#114](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/114)) ([9d76306](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/9d7630665413f4eca7456e0547596898a6d277ae))
* add support for context.Context to scylla provider and http client ([b0011cf](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/b0011cf374add2565eef59a26c61664ce397899d))
* add the optional node_disk_size attribute ([#125](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/125)) ([497ce37](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/497ce37759ff2fe9b1adcfcc2861b3d8b90e300d))
* **byoa:** Allow use of `byoa_id` when creating GCP clusters ([#206](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/206)) ([99a67c3](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/99a67c31df118a9ab546efc523bd4557050e5bb6))
* **cluster-connection:** implement conterpart for cluster connections api in particular tgw ([#115](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/115)) ([09cdd72](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/09cdd72864a760dba0bafd14797529461e3e7e56))
* **cluster:** add encryption_at_rest and replication_factor options ([#5](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/5)) ([3568511](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/3568511fac660a6d51a9738cc108e734da34d196))
* **peering:** add peer_cidr_blocks attribute for VPC peering ([80f09d8](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/80f09d834b8108f59bd3be56332f4bb98848ed8f))


### Bug Fixes

* **api-client:** handle `http.StatusTooManyRequests` ([#90](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/90)) ([0481d94](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/0481d948d05ba9dda033cd3a777bbb5313c81bfe))
* build cloudmeta before it's used by findAndSaveAccountID ([cf71aad](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/cf71aad1c8131809ed327155805171dd5d4fbb51))
* **cloud:** remove userFriendlyError, field is deprecated ([#190](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/190)) ([ea0b062](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/ea0b062b5dc691c03a48c15e4c3baf483580abcf))
* **cluster:** fix internal validation failure ([#102](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/102)) ([bbacc8d](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/bbacc8d76e8cc008a565040f0906f265af56af86))
* **cluster:** make it treat deleted cluster properly ([#135](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/135)) ([0058cd9](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/0058cd9846cd40ec4e33f06f1efdc19141389fa8))
* **examples:** correct provider path and example files ([#1](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/1)) ([1aa0a3a](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/1aa0a3ab609b274019ebad0a4a2dd9b7a720b4a7))
* handle AllowCQL and AlternatorWriteIsolation on resource read ([#109](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/109)) ([e894be7](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/e894be73d43bd9b7a9041652962186e15b2bb587))
* inconsistent resourceClusterCreate state ([9566ed1](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/9566ed187fae17ad97dee6033067fd2fde6f21a3))
* **serverless:** add processing units and expiration time for serverless ([#88](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/88)) ([34924c7](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/34924c732aba0e07dcd15bdf3fa2f201d3684d0c))
* **serverless:** catch 400001 error when cluster is gone ([1bfc3ff](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/1bfc3ff3f7f8c58bad893e92bfa65861625d5b6e))
* **vpc-peering:** delete state when object is deleted from the scylla cloud ([#138](https://github.com/vetric-io/terraform-provider-scylladbcloud/issues/138)) ([3a8ce93](https://github.com/vetric-io/terraform-provider-scylladbcloud/commit/3a8ce93e149bd09a888acd54dcec772c62f80bbb))

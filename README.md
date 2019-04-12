# Containerized SOLR On OpenShift
Apache SOLR makes it easy to add search capability into your apps.  SOLR is a search server (backed by the Lucene serach library).  This repository provides a way for you to take advantage of that in OpenShift or Minishift.

## There are 2 distinct parts to this repo:
   
### (1) A Dockerfile

Which overrides the [official Docker SOLR image][2] to tweak a few things in order to run SOLR efficiently on OpenShift.  

### (2) S2I scripts

Which allow you to easily push your project specific configuration files into the SOLR container.

### Quick Start
* Bring up a local OpenShift cluster.
  * There are some [Chocolatey Scripts](https://github.com/WadeBarnes/dev-tools/tree/master/chocolatey) that make it very easy to do this on Windows.
Or
* Bring up a local Minishift instance.
* Run the `buildLocalProject.sh -c` script in the `openshift` directory.

This will create a **Solr** project and generate all of the build and deployment configurations needed for a working Solr instance complete with some cores configured from source.
Withot option -c, you can generete all of the build and deployment configurations for an existing project.

### If you want to provide configuration in an automated way...
* Create a repo
* Put all cores config in a folder called `solr`, the cores will be created (or updated) when solr starting on OpenShift

### The S2I process
This repo doesn't require [the s2i tool](https://github.com/openshift/source-to-image) to build the image.  However, if you look into the Dockerfile, it does set some s2i LABELS in order for OpenShift to be able to use it as an s2i builder image.

#### assemble script
Refer to the documentation in the script for details.

#### run script
Refer to the documentation in the script for details.

## Want to help?
If you find and issues, go ahead and write them up.  If you want to submit some code changes, please see the [CONTRIBUTING][3] docs.


[1]: https://github.com/docker-solr/docker-solr
[2]: https://store.docker.com/images/f4e3929d-d8bc-491e-860c-310d3f40fff2?tab=description
[3]: ./CONTRIBUTING.md

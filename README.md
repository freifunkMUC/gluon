[![License](https://img.shields.io/badge/License-BSD%202--Clause-orange.svg)](https://opensource.org/license/bsd-2-clause/)

# Gluon

Gluon is a firmware framework to build preconfigured OpenWrt images for public mesh networks.

## Gluon-Parker

This is a fork of Gluon, that uses routing between the nodes (aka. Router devices) and the infrastructure.
It is currently in use by [Freifunk Braunschweig](https://freiunk-bs.de).
Other communities are interested in adopting it as well.

Documentation is currently sparse.
Some hints can be found here:

* https://media.ccc.de/v/35c3oio-69-project-parker-klassisches-routing-fr-freifunk
* https://freifunk-bs.de/parker.html

Not all features needed for a parker-style Gluon are currently upstream - they are kept in this repository.
In this repository we will keep a branch for every upstream development branch with our local changes on top.
These branches follow the upstream naming, so `v2023.2.x-parker` will track `v2023.2.x`.
Releases will be tagged with an additional suffix: Tag `v2023.2.4.1-parker` will be on top of `v2023.2.4`.

We are planning to bring all these changes into upstream Gluon.
Feel free to help!

Other packages needed for a parker-style Gluon are developed in the [community-packages](https://github.com/freifunk-gluon/community-packages) repository.
They are named `ffbs-parker-*`.

A parker-style network needs a different backend.
You can get some inspiration from [here](https://gitli.stratum0.org/ffbs/ffbs-ansible).

## Contributing

Pull Requests against this repo are welcome!
(Please only pull-request against changes done in this repository
All other Pull Requests should go to directly to Gluon.)

Please be aware that we may rebase our branches on top of upstream without a PR 🫠.

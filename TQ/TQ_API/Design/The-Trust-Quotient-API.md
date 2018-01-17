## Trust Quotient API

The Trust Quotient API is a central instance that receives user related ratings from authenticated trust sources. It will contain a test system as well as the live trust quotient computation system.

Trust sources will have to register as trust sources at the TiiQu Trust Quotient API. When they deliver user related ratings, they will have to authenticate themselves according to the OAuth 2.0 protocol. OAuth 2.0 has an integrated possibility of the user authorizing the trust source to share their data with TiiQu, and it is a good basis for GDPR compliance as well.

Classically the instance that holds and shares the data of a dedicated user acts as the OAuth 2.0 provider. In this case that would be the trust sources. As TiiQu is a central instance that collects ratings from various sources, this seems like an inverted situation. TiiQu would subscribe as an OAuth 2.0 client to all rating delivering instances and request their ratings on the user's behalf.


## Contents

- [TiiQu as OAuth 2.0 Provider or Client](#tiiqu-as-oauth-2.0-provider-or-client)
  - [OpenID as OAuth 2.0 Client](#openid-as-oauth-2.0-client)
  - [OpenID as OAuth Provider](#openid-as-oauth-2.0-provider)
  - [OpenID or pure OAuth 2.0](#openid-or-pure-oauth-2.0)
  - [Open API Docs](#open-api-docs)
  - [Selected admitted trust sources](#selected-admitted-trust-sources)
  - [TiiQu member as last control instance](#tiiqu-member-as-last-control-instance)
- [Trust Quotient Algorithm Test System](#trust-quotient-algorithm-test-system)

<!-- Classically the trsut sources would be clients because they deliver data.
Think about what happens if it is the other way around -->

## TiiQu as OAuth 2.0 Provider or Client

All trust sources deliver ratings for users to the TiiQu platform. So every rating relates to 

1. a user
2. a trust source 

Therefore an OAuth 2.0 based authentication and authorization is perfect for the Trust Quotient API.

### TiiQu as OAuth 2.0 Client

TiiQu has to register as a client at all the trust sources which have to be able to act as OAuth 2.0 providers. It is the classical setup, but there a some setbacks:

* All trust sources have to implement an OAuth 2.0 provider or use such a service.
* TiiQu has less control over the correctness of the trsut source's implementation of the OAuth protocol. 
* The trust source's implementations might vary slightly and TiiQu would have to hold several code versions to be adaptable to those differences.

### TiiQu as OAuth 2.0 Provider

This would be the inverted case of an OAuth 2.0 setup, where the data provider is the central data dedicated distributing instance. Here the Trust Quotient API would act as an OAuth 2.0 provider, and the trust sources would be relying parties who have to authenticate themselves with a clientID and a client secret at the TiiQu Trust Quotient API. The client secret is only enabled for confidential OAuth 2.0 clients. Confidential means that they are running in a secure environment where they can store a secret. This is a sensitive requirement given the fact that a trust source delivers sensitive user data too. Simple single page applications for example do not meet this criterium. Advantages of this inverted setup:

* TiiQu has control over the correctness of the implementation of the OAuth2.0 protocol.
* TiiQu sets the rules on the possible configurations and flows for the trust sources.
* TiiQu is able to protect their users in a uniform way.

In this setup the data exchange can happen as follows: 

2. The trust source sends their credentials and the user's trust source ID to the TiiQu Trust Quotient API.
2. TiiQu checks the trust source's credentials and matches the user's trust source ID with his TiiQu member ID.
3. TiiQu sends the user's access token and JWT (JSON Web Token) back to the trust source.
4. The trust source verifies TiiQu's integrity with the JWT and matches the user's TiiQu ID with his trust source ID.
5. With the access token, the trust source sends an rating update as a POST to the TiiQu trust Quotient API.

The user can be integrated into the process at initialization and/or activation of the new rating value at the TiiQu platform. Another option is that he only gives his consent for the data exchange after activating a trust source.


### OpenID or pure OAuth 2.0

OpenID Connect is an identity layer on top of OAuth 2.0. So one question is if TiiQu wants to be an OpenID provider with which the TiiQu members identify themselves. 

Both protocols offer the solution of direct client authentication. Here the user does not have to be an active part during the data transfer from the trust source to the TiiQu API.

### Open API Docs

The API docs will be public. Everybody can see what kind of data is transferred from the trust sources to the Trust Quotient API and how they can implement an interface.

### Selected admitted trust sources

A trust source will be examined and chosen carefully by TiiQu according to their 

* reputation
* rating context (no private behaviour rating is accepted)
* transparency on how they handle person related data

Trust sources which have passed this evaluation will have to register as Trust Quotient OAuth 2.0 clients for a secure transmission of the user's ratings and their own fixed parameters.

### TiiQu member as last control instance

The TiiQu member will be able to add and remove, activate and deactivate trust sources. They also literally allow the trust source to share their ratings with TiiQu during the OAuth 2.0 based authorization.

## Trust Quotient Algorithm Test System

The test system will consist of 

* virtual TiiQu members
* real trust sources with virtual parameters
* virtual trust sources with virtual parameters
* the actual TQ algorithm
* test versions of the TQ algorithm
* results from various test runs
* statistics of tests and results


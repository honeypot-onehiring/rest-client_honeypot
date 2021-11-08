# Welcome to RestClient Honeypot

## Overview

This gem is an extension to `rest-client` gem. It adds following functionality:

- provide json payload
- provide headers in payload hash
- parsed_body helper method

## Example usage

    RestClient.post('https://foo.com/users', json: { age: 5 })
    RestClient.put('https://foo.com/users/1', json: { age: 5 })
    RestClient.patch('https://foo.com/users/1', json: { age: 5 })
    RestClient.post('https://foo.com/users', json: { age: 5 }, headers: { authorization: 'Bearer xyz')
    RestClient.get('https://foo.com/users').parsed_body
    RestClient.get('https://foo.com/users').parsed_body(symbolize_keys: true)

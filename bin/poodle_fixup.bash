#!/bin/bash

# src env to get aws keys loaded
## GOLD shows what policy is on the listner     aws elb describe-load-balancers |vim -
 aws elb describe-load-balancers |vim -


aws --region us-east-1 elb describe-load-balancers  | jq -r ".[].LoadBalancerName" |
aws elb create-load-balancer-policy --load-balancer-name {}  --policy-name 2014-10-Poodle-fix  --policy-type-name SSLNegotiationPolicyType --policy-attributes AttributeName=Reference-Security-Policy,AttributeValue=ELBSecurityPolicy-2014-10

aws elb describe-load-balancers | jq ".LoadBalancerDescriptions|{ELBName: .[].LoadBalancerName, Polices: .[].Policies}"|less

echo cf-logsearch-web| parallel -rt "aws elb create-load-balancer-policy --load-balancer-name {}  --policy-name 2014-10-Poodle-fix  --policy-type-name SSLNegotiationPolicyType --policy-attributes AttributeName=Reference-Security-Policy,AttributeValue=ELBSecurityPolicy-2014-10 ;  aws elb set-load-balancer-policies-of-listener --load-balancer-name {} --load-balancer-port 443 --policy-names 2014-10-Poodle-fix"


for j in  cf-logsearch-web-2096050195.us-east-1.elb.amazonaws.com ; do
    echo -e "====\nChecking: $j"
    for i in ssl3 tls1 ; do
        if ($(echo|openssl s_client -connect $j:443 -${i} 2>&1 | egrep -q 'failure')) ; then echo -e "\tssl protocol $i: disabled"; else echo -e "\tssl protocol $i: enabled" ; fi
    done
done

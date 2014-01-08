lauren = require '../js/lauren.js'

generator = lauren.buildGenerator()
generator.addVariable "userName", lauren.regexGeneratorType(/[a-z]{7}[0-9a-z]/)

accessKeyGenerator = lauren.buildGenerator Math.floor(Math.random() * 2 + 1)
accessKeyGenerator.addRegexString "accessKeyId", /AKIA[A-Z0-9]{16}/
accessKeyGenerator.addStaticString "class", "com.amazonaws.services.identitymanagement.model.AccessKeyMetadata"
accessKeyGenerator.addRegexString "createDate", /2013-(10|11|12|0[1-9])-(2[0-8]|1[0-9]|0[1-9])T(2[0-3]|[01][0-9])(:[0-5][0-9]){2}\.000Z/
accessKeyGenerator.addFromArrayRandom "status", ["Active", "Inactive"]
accessKeyGenerator.addFromVariable "userName", "userName"

generator.addGenerator "accessKeys", accessKeyGenerator

attributeGenerator = lauren.buildGenerator 1
attributeGenerator.addRegexString "userId", /A[A-Z0-9]{20}/
attributeGenerator.addFromVariable "userName", "userName"
attributeGenerator.addCombo "arn", [lauren.regexGeneratorType(/arn:aws:iam::[0-9]{12}:user\//), lauren.fromVariableType "userName"]
attributeGenerator.addStaticString "class", "com.amazonaws.services.identitymanagement.model.User"
attributeGenerator.addRegexString "createDate", /2013-(10|11|12|0[1-9])-(2[0-8]|1[0-9]|0[1-9])T(2[0-3]|[01][0-9])(:[0-5][0-9]){2}\.000Z/
attributeGenerator.addStaticString "path", "/"

generator.addGenerator "attributes", attributeGenerator
generator.addArray "groups", ["Full", "Developers"], [1, .5]
generator.addFromVariable "name", "userName"
generator.addGenerator "userPolicies", lauren.buildGenerator 0

output = generator.output 10

console.log JSON.stringify(output)

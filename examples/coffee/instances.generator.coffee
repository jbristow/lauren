lauren = require '../js/lauren.js'

generator = lauren.buildGenerator 10
generator.addVariable "userName", lauren.regexGeneratorType(/[a-z]{7}[0-9a-z]/)
generator.addInt "amiLaunchIndex", 0, 0
generator.addFromArrayRandom "architecture", ["x86_64"]

bdmGenerator = lauren.buildGenerator 1
bdmGenerator.addStaticString "class", "com.amazonaws.services.ec2.model.InstanceBlockDeviceMapping"
bdmGenerator.addStaticString "deviceName", "/dev/sda1"

ebsGenerator = lauren.buildGenerator 1
ebsGenerator.addRegexString "attachTime", /2013-(10|11|12|0[1-9])-(2[0-8]|1[0-9]|0[1-9])T(2[0-3]|[01][0-9])(:[0-5][0-9]){2}\.000Z/
ebsGenerator.addStaticString "class", "com.amazonaws.services.ec2.model.EbsInstanceBlockDevice"
ebsGenerator.addBoolean "deleteOnTermination"
ebsGenerator.addStaticString "status", "attached"
ebsGenerator.addRegexString "volumeId", /vol-[1-9a-f][0-9a-f]{7}/

bdmGenerator.addGenerator "ebs", ebsGenerator

generator.addGenerator "blockDeviceMappings", bdmGenerator
generator.addStaticString "class", "com.amazonaws.services.ec2.model.Instance"
generator.addRegexString "clientToken", /[a-z0-9\-]{20}/
generator.addBoolean "ebsOptimized"
generator.addStaticString "hypervisor", "xen"
generator.addNull "iamInstanceProfile"
generator.addRegexString "imageId", /ami-[1-9a-f][0-9a-f]{7}/



output = generator.generate(null, null, [])

console.log JSON.stringify(output)


root = exports ? this

root.userUrl = (account) -> 
  "/edda/"+account+"/aws/iamUsers;_pp;_expand"
root.instanceUrl = (account,region) ->
  '/edda/'+region+'/'+account+'/view/instances;_pp;_expand'
root.matchesUserUrl = (account, url) ->
  root.userUrl(account) is url
root.matchesInstanceUrl = (account, regions, target) ->
  arr = []
  if regions instanceof Array
    arr = regions
  else
    arr = [regions]
  output = false
  urls = (root.instanceUrl(account, r) for r in arr)
  output = output or target is url for url in urls
  output

import yaml

def documents(name,**kwargs):
    with file('government-urls.yaml') as gov_urls_yaml:
        current_id=1
        urls_dict = yaml.load(gov_urls_yaml)
        collections = urls_dict.keys()
        for collection_name in collections:
            name_cleaned = collection_name.replace('usagov','').replace('gov','')
            name_cleaned = name_cleaned.lower()
            for url in urls_dict[collection_name]:
                data = {'_id': current_id,
                        'url':url,
                        'collection': name_cleaned}
                current_id += 1
                yield data


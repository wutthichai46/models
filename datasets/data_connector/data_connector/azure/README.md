# Data Connector Azure
Documentation
-------------

### Abstract
___
Data connector for Azure is a tool to connect to Azure Blob and Azure Machine Learning tools.

This tool requires an account on Azure Cloud and an Azure ML worskspace active.

Authentication
--------------
Authentication with Azure requires to install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
```bash
>az login
```
This command load certificates to login using simple authentication method. 


Storage
-----------
All Azure ML Workspaces has an storage blob, with this tool is possible connect to Azure Blob or Azure ML Storage. 

Azure ML
----------
Azure ML is a service to train models connecting data sources and deploy it in production using Azure infrastructure.

Data connector provides a tool to connect to Azure ML workspaces and upload configurations for this proposes.

Sample
---------
**Blob Connector**
```python
    from data_connector.azure import connect
    connection_string_sample = """
        DefaultEndpointsProtocol=http;
        AccountName=<YOUR_ACCOUNT_NAME>;
        AccountKey=<YOUR_ACCOUNT_KEY>
        BlobEndpoint=http://127.0.0.1:10000/
        devstoreaccount1;
        QueueEndpoint=http://127.0.0.1:10001/
        devstoreaccount1;
        TableEndpoint=http://127.0.0.1:10002/
        devstoreaccount1;
       """
    connector = connect(connection_string=connection_string_sample)

```
How to get a [Connection String](https://learn.microsoft.com/en-us/answers/questions/1071173/where-can-i-find-storage-account-connection-string)? 

![Azure Connection String Sample](data_connector/../../../docs/img/connection_string.png)

Also you can get connection strings using Azure CLI
```bash
>az storage account show-connection-string --name <storageAccount> --resource-group <resourceGroup> --subscription <subscription>
```
Or just 
```bash
>az storage account show-connection-string --name <storageAccount> 
```
* This process not works for WSL 


**Blob upload**
---------
```python
    from data_connector.azure import Uploader

    uploader = Uploader(connector= connector)
    uploader.upload(
        'sample.txt',
        blob_container_name='sample_container'
    )
```

**Blob downloader**
-----
```python
    from data_connector.azure import Downloader

    downloader = Downloader(connector=connector)
    downloader.download()
```

[See sample](../../samples/azure/blob_sample.py)
-----
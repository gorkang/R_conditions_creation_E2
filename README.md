# R_conditions_creation

## Workflow

### Feature branch

Deberiamos tener solo las siguientes ramas:  

* master  
* development  

Queremos implementar un nuevo feature o arreglar algun problema:

1. Creamos nueva rama (feature_x)  
`git checkout -b feature_x`

2. Hacemos cambios  
- Commiteamos los cambios

3. Si no esperamos conflictos - mergeamos rama a development 
`git checkout development`  
`git pull origin development`  
`git merge feature_x`  
`git push origin development`   

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

4. Si todo ha ido bien, borramos la rama `feature_x`  
`git branch -d feature_x`



### Stash

Hemos hecho algunos cambios pero no queremos hacer commit:  

`git stash`  

Recuperamos los cambios  

`git checkout rama_en_la_que_recuperar_cambios`  
`git stash apply`  


Queremos destruir el stash  

`git stash drop`  

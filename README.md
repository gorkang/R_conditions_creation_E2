## Workflow

Deberiamos tener solo las siguientes ramas en Github:  

* master  
* development  


### Feature branch

A) Queremos implementar un nuevo feature o arreglar algun problema:

1. Creamos nueva rama (feature_x)  
`git pull origin development`  
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

Si hemos hecho algunos cambios pero no queremos hacer commit, podemos stashearlos:  
`git stash`  

Para recuperar los cambios  
`git checkout rama_en_la_que_recuperar_cambios`  
`git stash apply`  


Si queremos destruir el stash  
`git stash drop`  


---  

## ERRORES COMUNES

### Merging

Si se da este error:  
`fatal: You are in the middle of a merge -- cannot amend.`

O también:  
`error: You have not concluded your merge (MERGE_HEAD exists).`
`hint: Please, commit your changes before merging.`
`fatal: Exiting because of unfinished merge.`

* SOLUTION:  
    + Do a `git commit -a` once you have resolved the conflicts. This is the last step when you are merging conflicts. (https://stackoverflow.com/questions/22135465/cant-commit-after-starting-a-merge-in-sourcetree)


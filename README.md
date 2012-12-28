ios-10k
=======

### Entities  

**Task Entity**

```json
[ Task: {  
            title: "Task title",  
            index: 0,
            creationDate: NSDate,
            sessions: [
                Session, Session, Session...
            ],
            tags: [
                Tag, Tag, Tag...
            ]
}]
```

**Session Entity**

```json
[ Session: {
   startDate: NSDate,
   endDate: NSDate 
}]
```

**Tag Entity**

```json
[ Tag: {
    name: "health"   
}]
```
ios-10k
=======

10,000 hours to mastery! 10K tracks your habits, goals, activities or anything that you want.  It's said that it takes 10,000 hours to achieve mastery in anything.


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

ios-10k
=======

### Models  

**Tasks** contain **Sessions** which are created by users whenever they want to log activity on a particular Task.

```json
[ Task: {  
            id: 293819,
            title: "Task title",  
            displayTime: '0:00:00',
            order: 0,
            totalSeconds: 0,
            creationDate: Date,
            sessions: [
                NSArray(Sessions)
            ],
            tags: [
                NSArray(Tags)
            ]
}]
```

**Sessions**

```json
[ Session: {
   id: 3829,
   startDate: Date,
   endDate: Date 
}]
```

**Tags**

```json
[ Tag: {
            id: 23,
            name: "health"   
}]
```
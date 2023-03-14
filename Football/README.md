### Matches Feature Specs
---

#### Story: User requests to see matches.

### Narative #1

>As an online user, 
>I want the app to automatically the matches
>So I can always see the matches.

##### Scenarios (Acceptance Criteria):

> Given the user has connectivity
> When the user requests to see matches
> Then the app should display the matches
> And replace the cache with the new data

### Narative #2

>  As an offline user, 
    I want the app to show the latest saved version of the matches
    So I can always see the matches.

##### Scenarios (Acceptance Criteria):

> Given the user doesn't have connectivity
> And there's a cached version of the matches.
> When the user requests to see the matches.
> Then the app should display the matches.
> 
> Given the user doesn't have connectivity
> And the cache is empty.
> When the user requests to see the matches.
> Then the app should display the error message.


## Use Cases
---

### Load Matches From Remote Use Case

##### Data:
- URL

##### Primary course (happy path):

1. Execute "Load Matches" command with the above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates matches from valid data.
5. System delivers matches.

##### Invalid data - error course (sad path):

1. System delivers invalid data error.

##### No Connectivity - error course (sad path):

1. System delivers connectivity error.

### Load Matches From Cache Use Case

##### Primary course (happy path):

1. Execute "Load Matches" command with the above data.
2. System retrieves matches data from the cache.
3. System creates matches from cached data.
4. System delivers matches.

##### Retrieval error course (sad path):

1. System delivers error.

##### Empty cache course (sad path):

1. System delivers no matches.

---
## Cache Matches Use Case

##### Data:
- Matches

##### Primary course (happy path):

1. Execute "Save Matches" command with the above data.
2. System deletes old cache data.
3. System saves new cache data.
4. System delivers a success message.

##### Deleting error course (sad path):

1. System delivers error.

##### Saving error course (sad path):

1. System delivers error.

---
### Model Specs

#### Matches
Property | Type 
--- | ---
`previous` | Array\<PreviousMatch\>
`upcoming` | Array\<UpcomingMatch\>


#### Match Protocol
Property | Type
--- | ---
`date` | Date (ISO8601 String)
`description` | String
`home` | String
`away` | String

#### PreviousMatch : Match
Property | Type
--- | ---
`winner` | String
`highlights` | URL

#### UpcomingMatch : Match

#### Payload contract

```
GET https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams/matches

200 RESPONSE

{
  "matches": {
    "previous": [
      {
        "date": "2022-04-23T18:00:00.000Z",
        "description": "Team Cool Eagles vs. Team Red Dragons",
        "home": "Team Cool Eagles",
        "away": "Team Red Dragons",
        "winner": "Team Red Dragons",
        "highlights": "https://tstzj.s3.amazonaws.com/highlights.mp4"
      }
    ],
    "upcoming": [
      {
        "date": "2023-08-13T20:00:00.000Z",
        "description": "Team Cool Eagles vs. Team Serious Lions",
        "home": "Team Cool Eagles",
        "away": "Team Serious Lions"
      }
    ]
  }
}
```

___

### Teams Feature Specs
---

#### Story: User requests to see teams.

### Narative #1

>  As an online user, 
    I want the app to automatically the teams
    So I can always see the teams.

##### Scenarios (Acceptance Criteria):

> Given the user has connectivity
> When the user requests to see teams
> Then the app should display the teams
> And replace the cache with the new data

### Narative #2

>  As an offline user, 
    I want the app to show the latest saved version of the teams
    So I can always see the teams.

##### Scenarios (Acceptance Criteria):

> Given the user doesn't have connectivity
> And there's a cached version of the teams.
> When the user requests to see the teams.
> Then the app should display the teams.
> 
> Given the user doesn't have connectivity
> And the cache is empty
> When the user requests to see the teams.
> Then the app should display the error message.

## Use Cases
---

### Load Teams From Remote Use Case

##### Data:
- URL

##### Primary course (happy path):

1. Execute "Load Teams" command with the above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates teams from valid data.
5. System delivers teams.

##### Invalid data - error course (sad path):

1. System delivers invalid data error.

##### No Connectivity - error course (sad path):

1. System delivers connectivity error.

---
### Load Teams From Cache Use Case

##### Primary course (happy path):

1. Execute "Load Teams" command with the above data.
2. System retrieves teams data from the cache.
3. System creates teams from cached data.
4. System delivers teams.

##### Retrieval error course (sad path):

1. System delivers error.

##### Empty cache course (sad path):

1. System delivers no matches.

---
## Cache Teams Use Case

##### Data:
- Teams

##### Primary course (happy path):

1. Execute "Save Teams" command with the above data.
2. System deletes old cache data.
3. System saves new cache data.
4. System delivers a success message.

##### Deleting error course (sad path):

1. System delivers error.

##### Saving error course (sad path):

1. System delivers error.

---
## Load Team Image Data From Remote Use Case

##### Data:
-   URL

##### Primary course (happy path):

1.  Execute "Load Image Data" command with above data.
2.  System downloads data from the URL.
3. System validates downloaded data.
4.  System delivers image data.

##### Cancel course:

1.  System does not deliver image data or error.

##### Retrieval error course (sad path):

1.  System delivers error.

##### Empty cache course (sad path):

1.  System delivers not found error.

---
## Load Team Image Data From Cache Use Case

##### Data:
-   URL

##### Primary course (happy path):

1.  Execute "Load Image Data" command with above data.
2.  System retrieves data from the cache.
3.  System delivers cached image data.

##### Cancel course:

1.  System does not deliver image data or error.

##### Retrieval error course (sad path):

1.  System delivers error.

##### Empty cache course (sad path):

1.  System delivers not found error.

---
## Cache Team Image Use Case

##### Data:
- Image Data

##### Primary course (happy path):

1. Execute "Save Image Data" command with the above data.
2. System caches image data.
3. System delivers success message.

##### Saving error course (sad path):

1. System delivers error.

---
### Model Specs

#### Team
Property | Type 
--- | ---
`id` | UDID
`name` | String
`logo` | URL

---
#### Payload contract

```
GET https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams

200 RESPONSE

{
  "teams": [
      {
      "id": "767ec50c-7fdb-4c3d-98f9-d6727ef8252b",
      "name": "Team Red Dragons",
      "logo": "https://tstzj.s3.amazonaws.com/dragons.png"
    },
    {
      "id": "7b4d8114-742b-4410-971a-500162101158",
      "name": "Team Cool Eagles",
      "logo": "https://tstzj.s3.amazonaws.com/eagle.png"
    }
  ]
}
```

---
## App Architecture

![](https://imgur.com/download/fKx2tjm)
![[footballapp.png]]

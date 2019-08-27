# BrewdogBeerChallenge
 For a better experience, the App should run on an iPhone X. I haven't thought of it for a different screen size.
 
 
### Architecture
For the architecture, I chose MVVM, DI and Navigator Pattern. The app is modularized in layers, following (or at the very least trying) Clean Architecture guidelines, and therefore divided, from higher to lower, into:

- UserInterface
- Repository
- BusinessUseCases
- Domain

**Why this decision**? 

- I believe DI helps abstract the code, not being necesary to know how to build an object along with its dependencies, and helps encapsulate your it too.
- The Navigator Pattern removes a lot of boilerplate from the Massive-V-C, specially with custom transitions as you can see in the *Splash* scene.
- MVVM is based on the observer pattern which works perfectly with RxSwift. Here, I haven't used this library in order to minimize dependencies, though. The observer pattern has been implemented by means of closures rather than protocols and weak references, taking advantage of the power of Swift.

### Unit Testing
The architecture allows to Unit Test the different components of the App. I've chosen to focus on the Repository and the Business Use Cases layers. This is due to the fact the UI is hard to test and it is likely to be changed more easily. Tests must be mantained and, in my opinion, the UI doesn't help to that maintenance.

Tests don't probably have a 100% coverage since that's hard to achieve and one could wonder if it's worth the effort to get such a percentage as even with 100% coverage bugs will still exist. For the purpose of the challenge, I've implemented several tests that have actually helped me implement the business components.

### GitFlow
In this repository, I've tried to use GitFlow Guidlines: branches come from master, are merged in develop and finally develop is merged into master. There's only one merge in this repo where I accidentally merged the branch directly into master. This could be done for hotfixes but this wasn't the case.

### UI
The starting point is a *Splash* view controller whose only purpose is to create a beautiful reveal animation to take us to the next screen, *Beers* list. 

In this scene, we can scroll down to see all the beers available. New pages will be requested and loaded on demand. Beers display some basic information that might be trimmed if too long. The title on the top of the table swipes beautifully with the list of beers and places itself on top of where the navbar title should be. Clicking on any of these beers we navigate to its *Detail*.

Finally, in this scene we find a bit of extra information about the beer itself, along with a list of its ingredients (hops and malts) and brew methods. Each of these are carefully assembled under sections. Also, they show a button that indicates the state of that step of the recipe. If we click it, the business logic will apply the requirements asked in the challenge and will switch to the appropriate state. When a method has any duration, I've assumed it is seconds and not minutes so that it is easily tested.

**Known issues**

- The property animator in BeersViewController fails to animate after we go back from the detail scene. Besides, the animation should be polished up as it doesn't really work as expected.
- Table View Cells have a static height and this should be retrieved from a property on the table view to calculate its height. So, the "magic number" should be substituted.
- In the splash scene there are several issues. One is that when transitioning to the next scene you can actually see a BrewDog logo increasing its size and another one staying where it was at the begining of the animation. I liked the effect so I didn't look into it. The other issue is that the background image is huge for such a screen. The App is just a sample and even though I haven't thought of it to fit any other screen size, I liked the idea that that scene would look good within a different device.
- The way I bindi the cells in the *Detail* scene doesn't convinced me very much.
- There aren't many comments in the code. I believe comments should be restricted to what's really necessary as "clean code speaks itself".
- Regarding the UI, I've chosen several approaches to do the same, for example, the background of the ABV label. I've done so to prove I'm familiar with layers and Core Animation and that I like coding simple UIViews that consist of multiple layers.
- Magic numbers should be erased from the project. Regarding colors, fonts, strings and the like, I usually recommend having a file with static values called *Colors*, *Fonts*, ... If targets are needed, you can easily change the whole design of an App by choosing a different file to compile for that new target.
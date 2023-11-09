# Components
Reusables that are needed in many scenes.

Many things could become components and be reusable many times, 
**but** undoing something reusable or working around it, can give a lot of work. Examples:  
- "Component A is used by scene Y and Z... If it was more generic I would be able to use on W too".
	- In this example the developer is trying to find a generic approach so it can fit more scenes.
		This can make the component much more complex just to fit it case, 
		my recommendation is just make scene for your scene.  
- "Scene Y would be cooler if component also did Z"
	- In this example the developer wants to add one feature to the component so it can fit
		his needs. If you want to add a feature, it needs to fit more than one scene (you could even
		create another component for this scenes).  
- "No scene use feature A from the component"
	- This could mean that the component could become simpler or rewrited... And this can
		bring a lot of work. This shows that this feature was a mistake.  

Only make something a component when you know for sure that will be used for many scenes
and the core feature will **NEVER** change.  

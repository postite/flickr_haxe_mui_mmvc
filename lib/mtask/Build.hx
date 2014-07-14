/**
	This class represents the build configuration of a project.

	At runtime, mtask will add any tasks of targets defined in this class to the project build. Use 
	the file and target API to define repeatable units of work and compilation targets.
**/
class Build extends mtask.core.BuildBase
{
	public function new()
	{
		super();
	}
}

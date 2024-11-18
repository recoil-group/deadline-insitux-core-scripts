# Limitations

This is a list of instances the modding API can't (and probably won't for a long time) support.
If the information here becomes wrong, you can make a post about it in the Deadline server.

| Name              | Use                         | Reason                                                                    | Forever?                                                                                     |
| ----------------- | --------------------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| MeshPart          | Mesh models with collisions | MeshParts are not editable at runtime                                     | Until EditableMesh releases(?), depending on the limitations of the API provided             |
| Terrain           | Terrain                     | Massive file size overhead, inconvenient voxel API for reading/writing it | Until I can be bothered to figure out how to store it, and when large mods become importable |
| MaterialVariant   | Custom textures             | MaterialVariants are not editable at runtime                              | Yes - Unless Roblox changes their API                                                        |
| SurfaceAppearance | PBR                         | PBR is not editable at runtime                                            | Yes - Unless Roblox changes their API                                                        |
| ParticleEmitter   | Particles                   | I'm lazy                                                                  | No. But I am pretty lazy                                                                     |

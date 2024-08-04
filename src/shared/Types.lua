export type CarSpawner = Model & {
    Station: Model & {
        Car: Model
    },
    Button: Part,
}

export type Map = Model & {
    SpawnPlate: Part,
    Targets: Folder & {Part},
}

return true
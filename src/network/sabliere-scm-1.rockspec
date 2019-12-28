package = "Sabliere"
version = "scm-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua >= 5.1, < 5.4",
   "luasocket",
   "bit32"
}
build = {
   type = "builtin",
   modules = {
      Client = "Client.lua",
      Connection = "Connection.lua",
      Data = "Data.lua",
      DuplexUpdate = "DuplexUpdate.lua",
      Host = "Host.lua",
      ["client.Requests"] = "client/Requests.lua",
      ["client.request.Get"] = "client/request/Get.lua",
      ["client.request.Post"] = "client/request/Post.lua",
      ["client.request.post.PostPlayer"] = "client/request/post/PostPlayer.lua",
      ["client.request.post.Snapshot"] = "client/request/post/Snapshot.lua",
      ["client.request.post.Tilemap"] = "client/request/post/Tilemap.lua",
      ["server.Requests"] = "server/Requests.lua",
      ["server.request.Get"] = "server/request/Get.lua",
      ["server.request.Post"] = "server/request/Post.lua",
      ["server.request.get.Player"] = "server/request/get/Player.lua",
      ["server.request.post.Duplex"] = "server/request/post/Duplex.lua",
      ["server.request.post.PostPlayer"] = "server/request/post/PostPlayer.lua",
      ["state.GameState"] = "state/GameState.lua",
      ["state.Level"] = "state/Level.lua",
      ["state.entity.Entity"] = "state/entity/Entity.lua",
      ["state.entity.EntityPhysics"] = "state/entity/EntityPhysics.lua",
      ["state.entity.Players"] = "state/entity/Players.lua",
      ["state.entity.Projectiles"] = "state/entity/Projectiles.lua",
      ["state.entity.movement.FallingState"] = "state/entity/movement/FallingState.lua",
      ["state.entity.movement.IdleState"] = "state/entity/movement/IdleState.lua",
      ["state.entity.movement.JumpingState"] = "state/entity/movement/JumpingState.lua",
      ["state.entity.movement.MovingState"] = "state/entity/movement/MovingState.lua",
      ["state.entity.projectile.Bullet"] = "state/entity/projectile/Bullet.lua",
      ["state.entity.projectile.Projectile"] = "state/entity/projectile/Projectile.lua",
      ["state.physics.BoxCollider"] = "state/physics/BoxCollider.lua",
      ["state.physics.Circle"] = "state/physics/Circle.lua",
      ["state.physics.HitboxCollider"] = "state/physics/HitboxCollider.lua",
      ["state.physics.Rectangle"] = "state/physics/Rectangle.lua",
      ["state.physics.TileCollision"] = "state/physics/TileCollision.lua",
      ["state.tilemap.Tile"] = "state/tilemap/Tile.lua",
      ["state.tilemap.TileTypes"] = "state/tilemap/TileTypes.lua",
      ["state.tilemap.Tilemap"] = "state/tilemap/Tilemap.lua"
   }
}

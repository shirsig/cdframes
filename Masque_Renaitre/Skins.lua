--[[ Renaitre skin suite for 5.4.7 ]]

local MSQ = LibStub("Masque", true)
if not MSQ then return end

-- Renaitre: Fade
MSQ:AddSkin("Renaitre: Fade", {
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Fade\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
}, true)

-- Renaitre: Square Thin
MSQ:AddSkin("Renaitre: Square Thin", {
	Icon = {
		Width = 34,
		Height = 34,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -3,
		OffsetY = -3,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
}, true)

-- Renaitre: Square Thin Light
MSQ:AddSkin("Renaitre: Square Thin Light", {
	Template = "Renaitre: Square Thin",
	Normal = {
		Width = 42,
		Height = 42,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\SquareThin\Border]],
	},
}, true)

-- Renaitre: Thinnerest
MSQ:AddSkin("Renaitre: Thinnerest", {
	Icon = {
		Width = 34,
		Height = 34,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Border]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Gloss]],
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
}, true)

-- Renaitre: Thinnerest Light
MSQ:AddSkin("Renaitre: Thinnerest Light", {
	Template = "Renaitre: Thinnerest",
	Normal = {
		Width = 42,
		Height = 42,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Renaitre\Textures\Thinnerest\Border]],
	},
}, true)

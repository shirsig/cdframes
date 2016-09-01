--[[ Elegance for Masque ]]

local MSQ = LibStub("Masque", true)
if not MSQ then return end

MSQ:AddSkin("Elegance: Light",{
	Author = "Kallieen",
	Version = "6.2.0",
	Shape = "Square",
	Masque_Version = 60200,
	
	-- Skin data start.
	Backdrop = {
		Width = 28,
		Height = 28,
		Texture = [[Interface\AddOns\Masque_Elegance\Textures\Background]],
		
	},
	Icon = {
		Width = 30,
		Height = 30,
		TexCoords = {0.07,0.93,0.07,0.93}, -- Keeps the icon from showing its "silvery" edges.
	},
	Border = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Elegance\Textures\Border]],
		BlendMode = "ADD",
	},
	Flash = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\AddOns\Masque_Elegance\Textures\Flash]],
	},
	Cooldown = {
		Width = 36,
		Height = 36,
	},
	AutoCast = {
		Width = 38,
		Height = 38,
	},
	AutoCastable = {
		Width = 58,
		Height = 58,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Normal = {
		Width = 36,
		Height = 36,
		Static = true,
		Texture = [[Interface\AddOns\Masque_Elegance\Textures\Normal]],
	},
	Pushed = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Addons\Masque_Elegance\Textures\Checked]],
		BlendMode = "ADD",
		Color = {1.0, 0.99, 0.86, 1.0},
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Addons\Masque_Elegance\Textures\Checked]],
		BlendMode = "ADD",
		Color = {0.42, 0.17, 0.71, 1.0}
	},
	Gloss = {
		Height = 36,
		Width = 36,
		Texture = [[Interface\Addons\Masque_Elegance\Textures\Gloss]],
	},
	Highlight = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Elegance\Textures\Highlight]],
		BlendMode = "ADD",
	},
	HotKey = {
		Width = 36,
		Height = 5,
		OffsetX = 4,
		OffsetY = -1,
		Fontsize = 14,
	},
	Count = {
		Width = 36,
		Height = 5,
		OffsetX = 0,
		OffsetY = 5,
		Fontsize = 12,
	},
	Name = {
		Width = 36,
		Height = 10,
		OffsetY = 0,
	},
	-- Skin data end.

},true)

MSQ:AddSkin("Elegance: Dark",{

	Template = "Elegance: Light",
	Normal = {
		Width = 36,
		Height = 36,
		Static = true,
		Texture = [[Interface\AddOns\Masque_Elegance\Textures\Normal]],
		Color = {0.0, 0.0, 0.0, 1}
	},

},true)

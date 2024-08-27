iris:Connect(function()
	iris.Window({"My Second Window"})
		iris.Text({"The current time is: " .. tick()})

		iris.InputText({"Enter Text"})

		if iris.Button({"Click me"}).clicked() then
			print("button was clicked")
		end

		iris.InputColor4()

		iris.Tree()
			for i = 1,8 do
				iris.Text({"Text in a loop: " .. i})
			end
		iris.End()
	iris.End()
end)
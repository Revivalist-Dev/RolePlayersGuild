<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ImageUploadAccordionItem.ascx.cs" Inherits="RolePlayersGuild.templates.controls.subcontrols.ImageUploadAccordionItem" ClientIDMode="AutoID" %>
<div class="panel panel-default">
    <div class="panel-heading">
        <h4 class="panel-title">
            <a class="accordion-toggle <%= CollapsedIfNotNumberOne() %>" data-toggle="collapse" data-parent="#pnlImageAccordion" href="#collapse<%= CurrentAccordionNumber() %>" aria-expanded="true">Image <%= CurrentAccordionNumber() %></a>
        </h4>
    </div>
    <div id="collapse<%= CurrentAccordionNumber() %>" class="panel-collapse collapse <%= InIfNumberOne() %>">
        <div class="panel-body">
            <div class="form-group">
                <label for="fuCharacterProfileImage">Display Image</label>
                <asp:FileUpload ID="fuCharacterProfileImage" runat="server" />
                <p class="help-block"><strong class="text-danger">NOTE:</strong> Please do <strong>not</strong> upload images with mature content. Violation of this rule may result in full account deletion without warning.</p>
            </div>
            <div class="form-group">
                <label for="txtCaption">Image Caption</label>
                <asp:TextBox ID="txtCaption" runat="server" CssClass="form-control" placeholder="You can be creative with your caption! Type as much as you like!" autofocus TextMode="MultiLine" Rows="4"></asp:TextBox>
            </div>

            <label for="chkMatureContent">Display Image?</label>
            <div class="checkbox">
                <label>
                    <asp:CheckBox ID="chkMakePrimary" ClientIDMode="Static" runat="server" Text="" />
                    Make this image my display image.
                </label>

            </div>

        </div>
    </div>
</div>
